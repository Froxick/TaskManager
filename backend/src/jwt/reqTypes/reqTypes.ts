export interface RefreshUserJwtTokens {
  refreshToken: string;
}
export interface LogoutUser extends RefreshUserJwtTokens {}
export interface RemoveAllTokens extends RefreshUserJwtTokens {}
