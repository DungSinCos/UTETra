package com.UTETra.app.service.impl;

import com.UTETra.app.dto.UploadResult;
import com.UTETra.app.entity.Product;
import com.UTETra.app.repository.ProductRepository;
import com.UTETra.app.service.CloudinaryService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.math.BigDecimal;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

/**
 * Checks how product images and their Cloudinary public ids are handled when a product is updated.
 * No Spring context or database: the transaction outcome is simulated by calling afterCompletion.
 */
@ExtendWith(MockitoExtension.class)
class ProductServiceImplImageTest {

    @Mock
    private ProductRepository productRepository;
    @Mock
    private CloudinaryService cloudinaryService;

    private ProductServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new ProductServiceImpl(productRepository, cloudinaryService);
        TransactionSynchronizationManager.initSynchronization(); // behave as if inside a transaction
    }

    @AfterEach
    void tearDown() {
        TransactionSynchronizationManager.clearSynchronization();
    }

    @Test
    void replacingImageStoresNewPublicIdAndDeletesOldOneOnlyAfterCommit() {
        Product existing = productWithImage("https://old", "utetra/products/old");
        stubFindAndSave(existing);
        when(cloudinaryService.uploadImage(any(), org.mockito.ArgumentMatchers.eq(CloudinaryService.FOLDER_PRODUCTS)))
                .thenReturn(new UploadResult("https://new", "utetra/products/new"));

        service.update(1L, changes(), newImage());

        assertThat(existing.getImageUrl()).isEqualTo("https://new");
        assertThat(existing.getImagePublicId()).isEqualTo("utetra/products/new");
        verify(cloudinaryService, never()).deleteImage(any()); // nothing deleted before the commit

        completeTransaction(TransactionSynchronization.STATUS_COMMITTED);

        verify(cloudinaryService).deleteImage("utetra/products/old");
        verify(cloudinaryService, never()).deleteImage("utetra/products/new");
    }

    @Test
    void rollbackDeletesTheNewUploadAndKeepsTheOldImage() {
        Product existing = productWithImage("https://old", "utetra/products/old");
        stubFindAndSave(existing);
        when(cloudinaryService.uploadImage(any(), org.mockito.ArgumentMatchers.eq(CloudinaryService.FOLDER_PRODUCTS)))
                .thenReturn(new UploadResult("https://new", "utetra/products/new"));

        service.update(1L, changes(), newImage());
        completeTransaction(TransactionSynchronization.STATUS_ROLLED_BACK);

        verify(cloudinaryService).deleteImage("utetra/products/new");
        verify(cloudinaryService, never()).deleteImage("utetra/products/old");
    }

    @Test
    void updatingWithoutNewImageKeepsUrlAndPublicIdAndNeverCallsCloudinary() {
        Product existing = productWithImage("https://old", "utetra/products/old");
        stubFindAndSave(existing);

        service.update(1L, changes(), null);
        completeTransaction(TransactionSynchronization.STATUS_COMMITTED);

        assertThat(existing.getImageUrl()).isEqualTo("https://old");
        assertThat(existing.getImagePublicId()).isEqualTo("utetra/products/old");
        verifyNoInteractions(cloudinaryService);
    }

    // ------------------------------------------------------------------ helpers

    private void stubFindAndSave(Product existing) {
        when(productRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(productRepository.save(any(Product.class))).thenAnswer(inv -> inv.getArgument(0));
    }

    private static Product productWithImage(String url, String publicId) {
        Product p = new Product();
        p.setId(1L);
        p.setName("Trà sữa");
        p.setCategoryId(1L);
        p.setBasePrice(BigDecimal.valueOf(45000));
        p.setImageUrl(url);
        p.setImagePublicId(publicId);
        return p;
    }

    private static Product changes() {
        Product c = new Product();
        c.setName("Trà sữa đổi tên");
        c.setCategoryId(1L);
        c.setBasePrice(BigDecimal.valueOf(47000));
        return c;
    }

    private static MockMultipartFile newImage() {
        return new MockMultipartFile("image", "new.png", "image/png", new byte[]{1, 2, 3});
    }

    /** Simulates the end of the transaction, which is what triggers the Cloudinary cleanup. */
    private static void completeTransaction(int status) {
        for (TransactionSynchronization sync : TransactionSynchronizationManager.getSynchronizations()) {
            sync.afterCompletion(status);
        }
    }
}
