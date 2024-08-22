package bitcube.framework.ebid.custom.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import bitcube.framework.ebid.core.CustomUserDetails;
import bitcube.framework.ebid.custom.service.ItemService;
import bitcube.framework.ebid.dto.ResultBody;
import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/api/v1/item")
public class ItemController {

	
    @Autowired
    private ItemService itemService;
    
    //품목 그룹 조회
    @PostMapping("/itemGrpList")
	@ResponseBody
    public ResultBody itemGrpList(HttpServletRequest httpServletRequest) throws Exception {
        return itemService.itemGrpList();
    }

    //품목 목록 조회
    @PostMapping("/itemList")
	@ResponseBody
    public ResultBody itemList(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) throws Exception {
        return itemService.itemList(params);
    }

    /*
    //품목 상세 조회
    @PostMapping("/{id}")
    @ResponseBody
    public ResultBody findById(@PathVariable String id) throws Exception {
        return itemService.findById(id);
    }
    */
    // 품목 수정
    @PostMapping("/saveUpdate")
	@ResponseBody
    public ResultBody saveUpdate(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params) {
        return itemService.saveUpdate(params);
    }
    // 품목 저장
    @PostMapping("/save")
	@ResponseBody
    public ResultBody save(HttpServletRequest httpServletRequest, @RequestParam Map<String, Object> params, @AuthenticationPrincipal CustomUserDetails user) {
        return itemService.save(params, user);
    }
    


}