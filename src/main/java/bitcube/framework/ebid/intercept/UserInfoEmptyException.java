package bitcube.framework.ebid.intercept;

@SuppressWarnings("serial")
public class UserInfoEmptyException extends RuntimeException {
	public UserInfoEmptyException() {
		super();
	}
	
	public UserInfoEmptyException(String message) {
		super(message);
	}
}