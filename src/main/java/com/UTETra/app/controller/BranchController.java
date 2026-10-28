package com.UTETra.app.controller;

import com.UTETra.app.entity.Branch;
import com.UTETra.app.service.BranchService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Objects;

/**
 * Public store branches listing page.
 */
@Controller
@RequestMapping("/branches")
public class BranchController {

    private final BranchService branchService;

    public BranchController(BranchService branchService) {
        this.branchService = branchService;
    }

    @GetMapping
    public String list(Model model) {
        List<Branch> branches = branchService.findActive();
        List<String> districts = branches.stream()
                .map(Branch::getDistrict)
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(d -> !d.isEmpty())
                .distinct()
                .sorted()
                .toList();

        model.addAttribute("branches", branches);
        model.addAttribute("totalBranches", branches.size());
        model.addAttribute("districts", districts);
        return "branches"; // -> /WEB-INF/views/branches.jsp
    }
}
