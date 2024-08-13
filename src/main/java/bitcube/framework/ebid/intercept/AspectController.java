package bitcube.framework.ebid.intercept;

import java.util.HashMap;
import java.util.Map;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.ui.Model;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import bitcube.framework.ebid.dto.UserDto;
import bitcube.framework.ebid.etc.util.Constances;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Aspect
@ComponentScan
@Slf4j
public class AspectController {
	
	/**
	 * 호출 메소드의 HttpServletRequest 파라미터를 반환하는 메소드
	 * 
	 * @param args
	 * @return HttpServletRequest
	 * @throws Exception
	 */
	private HttpServletRequest getHttpServletRequest(Object[] args) throws Exception{
		HttpServletRequest result = null;
		int				i	  = 0;
		
		for(i = 0; i < args.length; i++) {
			Object obj = args[i];
			
			if(obj instanceof HttpServletRequest){
				result = (HttpServletRequest)obj;
			}
			else if(obj instanceof MultipartHttpServletRequest){
				result = (MultipartHttpServletRequest)obj;
			}
		}
		
		return result;
	}
	
	private void joinPointArgCast(Object[] args, UserDto user){
		
		for(int i = 0 ; i < args.length ; i++) {
			if (args != null && args.length > 0 && args[i] instanceof Map<?, ?>) {
				Map<?, ?> originalMap = (Map<?, ?>) args[i];
	
				// 새로운 Map<String, Object>로 변환
				Map<String, Object> objectMap = new HashMap<>();
				
				for (Map.Entry<?, ?> entry : originalMap.entrySet()) {
					String key = (String) entry.getKey();
					objectMap.put(key, entry.getValue()); // 배열 전체를 Object로 저장
				}
				
				objectMap.put("userDto", user);
				args[i] = objectMap;
			}
		}
	}
	
	@Around("execution(* bitcube.framework.ebid..*Controller.*(..))"
			+ "&& !execution(* bitcube.framework.ebid.common.controller.GeneralController.*(..))"
			+ "&& !execution(* bitcube.framework.ebid.core.LoginController.*(..))")
	public Object execute(ProceedingJoinPoint joinPoint) throws Throwable {
		Object[]			args		= joinPoint.getArgs();
		HttpServletRequest	request		= this.getHttpServletRequest(args);			// 리퀘스트 정보 반환
		HttpSession		session		= request != null ? request.getSession() : null;
		UserDto user = session != null ? (UserDto) session.getAttribute(Constances.SESSION_NAME) : null;
		
		// 메서드 실행 전 처리 로직
		log.info("Before method: " + joinPoint.getSignature().getName());
		String method = joinPoint.getSignature().getName();
		
		if(!method.equals("login") && user == null) {
			
		}else if(!method.equals("login") && user != null) {
			//세션 마감 안됐을 때 로그인 정보 입력
			this.joinPointArgCast(args, user);
			return joinPoint.proceed(args);
		}
		Object result;

		try {
			// 메서드 실행
			result = joinPoint.proceed();
		} finally {
			// 메서드 실행 후 처리 로직
			log.info("After method: " + joinPoint.getSignature().getName());
		}

		return result;
	}
}
