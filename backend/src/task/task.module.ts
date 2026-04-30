import { Module } from '@nestjs/common';
import { TaskController } from './task.controller';
import { TaskService } from './task.service';
import { TaskRepository } from './task.repository';
import { PrismaModule } from 'src/prisma/prisma.module';
import { JwtModule } from 'src/jwt/jwt.module';
import { AuthGuard } from 'src/Guards/AuthGuard';

@Module({
  imports: [PrismaModule, JwtModule],
  controllers: [TaskController],
  providers: [TaskService, TaskRepository, AuthGuard],
})
export class TaskModule {}
