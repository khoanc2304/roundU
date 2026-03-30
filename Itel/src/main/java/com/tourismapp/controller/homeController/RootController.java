package com.tourismapp.controller.homeController;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.tourismapp.config.ProjectPaths;

@Controller
public class RootController {

    @GetMapping("/")
    public String redirectRoot() {
        // Redirection to the actual home page, bypassing the 404 at the absolute root.
        String contextPathRedirect = ProjectPaths.HREF_TO_HOMEPAGE.substring(ProjectPaths.PREFIX_WEB_PATH.length());
        return "redirect:" + contextPathRedirect;
    }
}
