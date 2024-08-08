package bitcube.framework.ebid.core;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class AuthToken {
    private String custType;
    private String custCode;
    private String custName;
    private String userId;
    private String userName;
    private String userAuth;
    private String token;
    private boolean sso;
}
