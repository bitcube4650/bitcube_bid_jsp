package bitcube.framework.ebid.core.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.logout.HttpStatusReturningLogoutSuccessHandler;
import org.springframework.security.web.header.writers.StaticHeadersWriter;

import bitcube.framework.ebid.core.CustomUserDetailsService;


@Configuration
@EnableWebSecurity
@ComponentScan
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class SecurityConfiguration {
	
	private final CustomUserDetailsService customUserDetailsService;
	private final Environment environment;
	
	@Autowired
	public SecurityConfiguration(CustomUserDetailsService customUserDetailsService, Environment environment) {
		this.customUserDetailsService = customUserDetailsService;
		this.environment = environment;
	}
 
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
		return authenticationConfiguration.getAuthenticationManager();
	}
	
	@Bean
	public DaoAuthenticationProvider daoAuthenticationProvider() {
		DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
		provider.setUserDetailsService(customUserDetailsService);
		provider.setPasswordEncoder(passwordEncoder());
		return provider;
	}
	
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http
			.csrf(csrf -> csrf.disable())
			.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.NEVER))
			.authorizeHttpRequests(authorize -> authorize
				.requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
				.requestMatchers("/actuator/**").permitAll()
				.requestMatchers("/login", "/logout").permitAll()
				.requestMatchers("/login/ssoRathon").permitAll()
				.requestMatchers("/dispatch/*").permitAll()
				.requestMatchers("/dispatch/**").permitAll()
				.requestMatchers("/api/v1/user*/**").permitAll()
				.requestMatchers("/api/v1/download2*/**", "/home", "/login/**").permitAll()
				.requestMatchers("/v2/api-docs", "/swagger-resources/**", "/swagger-ui.html", "/webjars", "/webjars/**").permitAll()
				.anyRequest().authenticated())
			.logout(logout -> logout
				.logoutSuccessHandler(new HttpStatusReturningLogoutSuccessHandler(HttpStatus.OK)))
			.headers(headers -> headers
				.frameOptions(frameOptions -> frameOptions.disable())
				.addHeaderWriter(new StaticHeadersWriter("X-FRAME-OPTIONS", 
					"ALLOW-FROM http://" + environment.getProperty("server.domain-name") + "/")));

		return http.build();
	}
}
