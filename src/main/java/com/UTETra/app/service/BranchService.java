package com.UTETra.app.service;

import com.UTETra.app.entity.Branch;

import java.util.List;

/**
 * Business operations for UTETra store branches.
 */
public interface BranchService {

    /**
     * Retrieve all branches (active and inactive) for admin management.
     */
    List<Branch> findAll();

    /**
     * Retrieve all active branches for public viewing.
     */
    List<Branch> findActive();

    /**
     * Total number of active branches.
     */
    long countActive();

    /**
     * Total number of branches.
     */
    long countTotal();

    /**
     * Find a branch by its ID.
     */
    Branch getById(Long id);

    /**
     * Create a new store branch.
     */
    Branch create(Branch branch);

    /**
     * Update an existing store branch.
     */
    Branch update(Long id, Branch changes);

    /**
     * Deactivate a store branch (temporarily hide from public view).
     */
    void deactivate(Long id);

    /**
     * Reactivate a store branch.
     */
    void activate(Long id);
}
