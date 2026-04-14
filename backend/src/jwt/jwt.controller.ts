import {
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { JwtService } from './jwt.service';
import { RefreshTokenDto } from './dto/refreshDto';
import { AuthGuard } from 'src/Guards/AuthGuard';
import type { RequestWithUser } from 'src/types/request.with.user';

@Controller('jwt')
export class JwtController {
  constructor(private jwtService: JwtService) {}

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @UsePipes(new ValidationPipe({ whitelist: true, transform: true }))
  async refreshUserTokens(@Body() dto: RefreshTokenDto) {
    const tokens = await this.jwtService.refreshUserTokens(dto.refreshToken);
    return { tokens };
  }

  @Post('logout')
  @HttpCode(HttpStatus.OK)
  @UsePipes(new ValidationPipe({ whitelist: true, transform: true }))
  async logoutUser(@Body() dto: RefreshTokenDto) {
    await this.jwtService.logoutRefreshToken(dto.refreshToken);
    return { success: true };
  }

  @Post('remove-all')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async removeAllRefreshUserTokens(@Req() req: RequestWithUser) {
    await this.jwtService.revokeAllUserRefreshTokens(req.user.id);
    return { success: true };
  }

  @Post('get-tokens')
  @HttpCode(HttpStatus.OK)
  @UsePipes(new ValidationPipe({ whitelist: true, transform: true }))
  async getUserRefreshTokens(@Body('email') email: string) {
    const tokens = await this.jwtService.getUserTokens(email);
    return { tokens };
  }
}
