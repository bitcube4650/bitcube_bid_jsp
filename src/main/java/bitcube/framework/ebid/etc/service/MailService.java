package bitcube.framework.ebid.etc.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.etc.util.consts.DB;

@Service
@RequiredArgsConstructor
@Slf4j
public class MailService {
    
    @Autowired
    private GeneralDao generalDao;
    @Transactional
    public void saveMailInfo(String title, String content, String userMail) {
    	Map<String, Object> params = new HashMap<String, Object>();
    	params.put("title", title);
    	params.put("content", content);
    	params.put("userMail", userMail);
    	try {
    		generalDao.insertGernal(DB.QRY_INSERT_MAIL_INFO, params);
    	}catch(Exception e) {
    		log.error("mail info insert error");
    		log.error(e.getMessage());
    	}
    }



}

