// import { RefreshToken } from "prisma/src/generated"

import { RefreshToken } from 'generated/prisma/client';
import { JwtData } from './jwt.data';

export interface userTokens {
  accesToken: string;
  refreshToken: string;
}
export interface IJwtService {
  getUserTokens(email: string): Promise<RefreshToken[]>;
  generateTokens(data: JwtData): Promise<userTokens>;
  createRefreshToken(userId: number): Promise<string>;
  createAccesToken(data: JwtData): string;
  verefiyAccesToken(token: string): JwtData | null;
  refreshUserTokens(refreshToken: string): Promise<userTokens>;
  revokeAllUserRefreshTokens(userId: number): Promise<void>;
  logoutRefreshToken(refreshToken: string): Promise<void>;
}
