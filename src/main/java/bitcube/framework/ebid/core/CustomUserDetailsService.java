package bitcube.framework.ebid.core;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import bitcube.framework.ebid.dao.GeneralDao;
import bitcube.framework.ebid.etc.util.consts.DB;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CustomUserDetailsService implements UserDetailsService {

	@Autowired
	private GeneralDao generalDao;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		CustomUserDetails user = findUser(username);
		if(user == null) {
			throw new UsernameNotFoundException(username);
		}
		return user;
	}

	public CustomUserDetails findUser(String username) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("userId", username);
		try {
			CustomUserDetails customUserDetails = (CustomUserDetails) generalDao.selectGernalObject(DB.QRY_SELECT_CUSTOM_USER_DETAILS, paramMap);
			return customUserDetails;
		} catch (Exception e) {
			log.error("findUser error : {}", e);
			return null;
		}
	}

}