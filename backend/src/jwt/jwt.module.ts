import { Module } from '@nestjs/common';
import { JwtService } from './jwt.service';
import { JwtController } from './jwt.controller';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthGuard } from 'src/Guards/AuthGuard';

@Module({
  imports: [PrismaModule],
  providers: [JwtService, AuthGuard],
  controllers: [JwtController],
  exports: [JwtService],
})
export class JwtModule {}
