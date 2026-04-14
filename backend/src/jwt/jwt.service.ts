import { Injectable } from '@nestjs/common';
import { IJwtService, userTokens } from './jwt.service.interface';
import { PrismaService } from 'src/prisma/prisma.service';
import { JwtData } from './jwt.data';
import { AppException } from 'src/common/exceptions/app.exception';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { ConfigService } from '@nestjs/config';
import crypto from 'crypto';
import { RefreshToken } from 'generated/prisma/client';

@Injectable()
export class JwtService implements IJwtService {
  constructor(
    private prisma: PrismaService,
    private configService: ConfigService,
  ) {}

  async generateTokens(data: JwtData): Promise<userTokens> {
    try {
      const accesToken = this.createAccesToken(data);
      const refreshToken = await this.createRefreshToken(data.id);

      return {
        accesToken,
        refreshToken,
      } as userTokens;
    } catch (e) {
      if (e instanceof AppException) throw e;
      throw new AppException('Ошибка сервера', 500);
    }
  }
  createAccesToken(data: JwtData): string {
    const jwtData = jwt.sign(
      data,
      this.configService.get<string>('JWT_SECRET') as string,
      { expiresIn: '15m' },
    );

    return jwtData;
  }
  async createRefreshToken(userId: number): Promise<string> {
    const token = crypto.randomBytes(40).toString('hex');

    const hashedToken = this.hashToken(token);

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 30);
    await this.prisma.refreshToken.create({
      data: {
        token: hashedToken,
        userId,
        expiresAt,
      },
    });
    return token;
  }

  verefiyAccesToken(token: string): JwtData | null {
    try {
      const verify = jwt.verify(
        token,
        this.configService.get<string>('JWT_SECRET') as string,
      ) as JwtPayload;
      return {
        email: verify.email,
        id: verify.id,
        name: verify.name,
        iat: verify.iat,
        exp: verify.exp,
      } as JwtData;
    } catch (e) {
      throw new AppException('Токен не валиден', 401);
    }
  }
  async getUserTokens(email: string): Promise<RefreshToken[]> {
    try {
      const user = await this.prisma.user.findFirst({
        where: {
          email,
        },
      });
      const tokens = await this.prisma.refreshToken.findMany({
        where: {
          userId: user?.id,
        },
      });
      return tokens;
    } catch (e) {
      if (e instanceof AppException) throw e;
      throw new AppException('Ошибка сервера', 500);
    }
  }
  async refreshUserTokens(refreshToken: string): Promise<userTokens> {
    try {
      const hashRefreshToken = this.hashToken(refreshToken);

      const activiteToken = await this.prisma.refreshToken.findFirst({
        where: {
          expiresAt: { gt: new Date() },
          revoked: false,
          token: hashRefreshToken,
        },
        include: { user: true },
      });
      if (!activiteToken) {
        throw new AppException('Токен не валиден', 401);
      }
      await this.prisma.refreshToken.delete({
        where: {
          id: activiteToken.id,
        },
      });
      const data: JwtData = {
        id: activiteToken.user.id,
        email: activiteToken.user.email,
        name: activiteToken.user.name,
      };
      const tokens = await this.generateTokens(data);

      return tokens;
    } catch (e) {
      if (e instanceof AppException) throw e;
      throw new AppException('Ошибка сервера', 500);
    }
  }
  async revokeAllUserRefreshTokens(userId: number): Promise<void> {
    try {
      await this.prisma.refreshToken.updateMany({
        where: { userId },
        data: {
          revoked: true,
        },
      });
    } catch (e) {
      throw new AppException('Ошибка сервера', 500);
    }
  }
  async logoutRefreshToken(refreshToken: string): Promise<void> {
    try {
      const hashToken = this.hashToken(refreshToken);
      const activiteToken = await this.prisma.refreshToken.findFirst({
        where: {
          expiresAt: { gt: new Date() },
          revoked: false,
          token: hashToken,
        },
        include: { user: true },
      });

      if (!activiteToken) {
        throw new AppException('Токен не валиден', 401);
      }
      await this.prisma.refreshToken.delete({
        where: {
          id: activiteToken.id,
        },
      });
      return;
    } catch (e) {
      if (e instanceof AppException) throw e;
      else {
        throw new AppException('Ошибка сервера', 500);
      }
    }
  }
  private hashToken(token: string): string {
    return crypto.createHash('sha256').update(token).digest('hex');
  }
}
