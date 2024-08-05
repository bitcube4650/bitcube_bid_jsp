package bitcube.framework.ebid.etc.util;

import org.springframework.jdbc.support.JdbcUtils;

import java.util.HashMap;

@SuppressWarnings({ "rawtypes", "serial", "unchecked" })
public class CamelMap extends HashMap {
	
	public Object put(Object key, Object value) {
		return super.put(JdbcUtils.convertUnderscoreNameToPropertyName((String) key), value);
	}
}
