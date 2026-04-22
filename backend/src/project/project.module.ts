import { Module } from '@nestjs/common';
import { ProjectController } from './project.controller';
import { ProjectService } from './project.service';
import { ProjectRepository } from './project.repository';
import { PrismaModule } from 'src/prisma/prisma.module';
import { AuthGuard } from 'src/Guards/AuthGuard';
import { JwtModule } from 'src/jwt/jwt.module';

@Module({
  imports: [PrismaModule, JwtModule],
  controllers: [ProjectController],
  providers: [ProjectService, ProjectRepository, AuthGuard],
})
export class ProjectModule {}
