package com.UTETra.app.service.impl;

import com.UTETra.app.entity.Branch;
import com.UTETra.app.exception.ResourceNotFoundException;
import com.UTETra.app.repository.BranchRepository;
import com.UTETra.app.service.BranchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class BranchServiceImpl implements BranchService {

    private static final Logger log = LoggerFactory.getLogger(BranchServiceImpl.class);

    private final BranchRepository branchRepository;

    public BranchServiceImpl(BranchRepository branchRepository) {
        this.branchRepository = branchRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Branch> findAll() {
        try {
            List<Branch> list = branchRepository.findAllByOrderByIdAsc();
            if (list != null && !list.isEmpty()) {
                return list;
            }
        } catch (Exception ex) {
            log.warn("Cannot fetch all branches from database ({}), falling back to sample data", ex.getMessage());
        }
        return getSampleBranches();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Branch> findActive() {
        try {
            List<Branch> list = branchRepository.findByActiveTrueOrderByIdAsc();
            if (list != null && !list.isEmpty()) {
                return list;
            }
        } catch (Exception ex) {
            log.warn("Cannot fetch active branches from database ({}), falling back to sample data", ex.getMessage());
        }
        return getSampleBranches();
    }

    @Override
    @Transactional(readOnly = true)
    public long countActive() {
        try {
            List<Branch> list = branchRepository.findByActiveTrueOrderByIdAsc();
            if (list != null && !list.isEmpty()) {
                return list.size();
            }
        } catch (Exception ignored) {
        }
        return getSampleBranches().size();
    }

    @Override
    @Transactional(readOnly = true)
    public long countTotal() {
        try {
            long count = branchRepository.count();
            if (count > 0) {
                return count;
            }
        } catch (Exception ignored) {
        }
        return getSampleBranches().size();
    }

    @Override
    @Transactional(readOnly = true)
    public Branch getById(Long id) {
        try {
            return branchRepository.findById(id)
                    .orElseGet(() -> findInSample(id));
        } catch (Exception ex) {
            return findInSample(id);
        }
    }

    @Override
    public Branch create(Branch branch) {
        validate(branch);

        String trimmedCode = branch.getCode().trim().toUpperCase();
        try {
            if (branchRepository.existsByCodeIgnoreCase(trimmedCode)) {
                throw new IllegalArgumentException("Mã chi nhánh '" + trimmedCode + "' đã tồn tại");
            }
        } catch (IllegalArgumentException ex) {
            throw ex;
        } catch (Exception ex) {
            log.warn("Could not check code uniqueness via DB: {}", ex.getMessage());
        }

        branch.setId(null);
        branch.setCode(trimmedCode);
        branch.setName(branch.getName().trim());
        branch.setAddressLine(branch.getAddressLine().trim());
        branch.setDistrict(branch.getDistrict().trim());
        branch.setCity(branch.getCity().trim());
        branch.setPhone(blankToNull(branch.getPhone()));
        branch.setActive(true);

        return branchRepository.save(branch);
    }

    @Override
    public Branch update(Long id, Branch changes) {
        Branch existing = getById(id);
        validate(changes);

        String trimmedCode = changes.getCode().trim().toUpperCase();
        try {
            if (branchRepository.existsByCodeIgnoreCaseAndIdNot(trimmedCode, id)) {
                throw new IllegalArgumentException("Mã chi nhánh '" + trimmedCode + "' đã được sử dụng bởi chi nhánh khác");
            }
        } catch (IllegalArgumentException ex) {
            throw ex;
        } catch (Exception ex) {
            log.warn("Could not check code uniqueness via DB: {}", ex.getMessage());
        }

        existing.setCode(trimmedCode);
        existing.setName(changes.getName().trim());
        existing.setAddressLine(changes.getAddressLine().trim());
        existing.setDistrict(changes.getDistrict().trim());
        existing.setCity(changes.getCity().trim());
        existing.setPhone(blankToNull(changes.getPhone()));

        return branchRepository.save(existing);
    }

    @Override
    public void deactivate(Long id) {
        Branch branch = getById(id);
        branch.setActive(false);
        branchRepository.save(branch);
    }

    @Override
    public void activate(Long id) {
        Branch branch = getById(id);
        branch.setActive(true);
        branchRepository.save(branch);
    }

    private void validate(Branch branch) {
        if (branch == null) {
            throw new IllegalArgumentException("Dữ liệu chi nhánh không hợp lệ");
        }
        if (branch.getCode() == null || branch.getCode().isBlank()) {
            throw new IllegalArgumentException("Mã chi nhánh không được để trống");
        }
        if (branch.getCode().trim().length() > 30) {
            throw new IllegalArgumentException("Mã chi nhánh tối đa 30 ký tự");
        }
        if (branch.getName() == null || branch.getName().isBlank()) {
            throw new IllegalArgumentException("Tên chi nhánh không được để trống");
        }
        if (branch.getName().trim().length() > 150) {
            throw new IllegalArgumentException("Tên chi nhánh tối đa 150 ký tự");
        }
        if (branch.getAddressLine() == null || branch.getAddressLine().isBlank()) {
            throw new IllegalArgumentException("Địa chỉ cụ thể không được để trống");
        }
        if (branch.getAddressLine().trim().length() > 255) {
            throw new IllegalArgumentException("Địa chỉ cụ thể tối đa 255 ký tự");
        }
        if (branch.getDistrict() == null || branch.getDistrict().isBlank()) {
            throw new IllegalArgumentException("Quận/huyện không được để trống");
        }
        if (branch.getDistrict().trim().length() > 100) {
            throw new IllegalArgumentException("Quận/huyện tối đa 100 ký tự");
        }
        if (branch.getCity() == null || branch.getCity().isBlank()) {
            throw new IllegalArgumentException("Tỉnh/thành phố không được để trống");
        }
        if (branch.getCity().trim().length() > 100) {
            throw new IllegalArgumentException("Tỉnh/thành phố tối đa 100 ký tự");
        }
        if (branch.getPhone() != null && branch.getPhone().trim().length() > 20) {
            throw new IllegalArgumentException("Số điện thoại tối đa 20 ký tự");
        }
    }

    private String blankToNull(String text) {
        if (text == null || text.isBlank()) {
            return null;
        }
        return text.trim();
    }

    private Branch findInSample(Long id) {
        return getSampleBranches().stream()
                .filter(b -> b.getId().equals(id))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Branch", id));
    }

    private List<Branch> getSampleBranches() {
        List<Branch> samples = new ArrayList<>();
        samples.add(buildBranch(1L, "UTE-TD-01", "UTETra Thủ Đức - Võ Văn Ngân", "028 3896 8641",
                "1 Võ Văn Ngân, Phường Linh Chiểu", "TP. Thủ Đức", "TP. Hồ Chí Minh"));
        samples.add(buildBranch(2L, "UTE-Q1-01", "UTETra Quận 1 - Nguyễn Huệ", "028 3822 5566",
                "68 Nguyễn Huệ, Phường Bến Nghé", "Quận 1", "TP. Hồ Chí Minh"));
        samples.add(buildBranch(3L, "UTE-Q5-01", "UTETra Quận 5 - An Dương Vương", "028 3835 2020",
                "280 An Dương Vương, Phường 4", "Quận 5", "TP. Hồ Chí Minh"));
        samples.add(buildBranch(4L, "UTE-BT-01", "UTETra Bình Thạnh - Điện Biên Phủ", "028 5445 7777",
                "475A Điện Biên Phủ, Phường 25", "Quận Bình Thạnh", "TP. Hồ Chí Minh"));
        samples.add(buildBranch(5L, "UTE-GV-01", "UTETra Gò Vấp - Quang Trung", "028 3989 1234",
                "656 Quang Trung, Phường 11", "Quận Gò Vấp", "TP. Hồ Chí Minh"));
        samples.add(buildBranch(6L, "UTE-Q10-01", "UTETra Quận 10 - Sư Vạn Hạnh", "028 3862 8899",
                "11 Sư Vạn Hạnh, Phường 12", "Quận 10", "TP. Hồ Chí Minh"));
        return samples;
    }

    private Branch buildBranch(Long id, String code, String name, String phone,
                               String addressLine, String district, String city) {
        Branch b = new Branch();
        b.setId(id);
        b.setCode(code);
        b.setName(name);
        b.setPhone(phone);
        b.setAddressLine(addressLine);
        b.setDistrict(district);
        b.setCity(city);
        b.setActive(true);
        return b;
    }
}
