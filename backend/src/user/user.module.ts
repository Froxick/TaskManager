import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { JwtModule } from '../jwt/jwt.module';
import { UserRepository } from './userRepository';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthGuard } from 'src/Guards/AuthGuard';

@Module({
  imports: [JwtModule, PrismaModule],
  controllers: [UserController],
  providers: [UserService, UserRepository, AuthGuard],
})
export class UserModule {}
