import { Injectable } from '@nestjs/common';
import { BaseRepository } from '../common/BaseRepository/BaseRepository';
import { Prisma, Task } from 'generated/prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { TaskFilterDto } from './DTO/taskFilterDto';
@Injectable()
export class TaskRepository extends BaseRepository<
  Task,
  Prisma.TaskWhereUniqueInput,
  Prisma.TaskWhereInput,
  Prisma.TaskCreateInput,
  Prisma.TaskUpdateInput,
  Prisma.TaskOrderByWithRelationInput
> {
  constructor(private prisma: PrismaService) {
    super(prisma.task);
  }

  async getTasks(projectId: number, filters: TaskFilterDto, userId: number) {
    const where: Prisma.TaskWhereInput = {
      projectId,
      project: {
        userId,
      },
      ...(filters.status && { status: filters.status }),
    };

    let orderBy: Prisma.TaskOrderByWithRelationInput = {
      createdAt: 'desc',
    };

    if (filters.sortBy) {
      orderBy = {
        [filters.sortBy]: filters.order || 'desc',
      };
    }

    return this.prisma.task.findMany({
      where,
      orderBy,
    });
  }
  async findProject(projectId: number) {
    return this.prisma.project.findFirst({
      where: {
        id: projectId,
      },
    });
  }
  async startTimer(id: number, userId: number) {
    return this.prisma.task.updateMany({
      where: {
        id,
        project: { userId },
      },
      data: {
        isTimerRunning: true,
        lastTimerStart: new Date(),
      },
    });
  }
  async stopTimer(id: number, userId: number) {
    const task = await this.prisma.task.findFirst({
      where: {
        id,
        project: { userId },
      },
    });

    if (!task || !task.lastTimerStart) return;

    const now = new Date();
    const diff =
      (now.getTime() - task.lastTimerStart.getTime()) / 1000 / 60 / 60;

    return this.prisma.task.update({
      where: { id },
      data: {
        actualHours: (task.actualHours || 0) + diff,
        isTimerRunning: false,
        lastTimerStart: null,
      },
    });
  }
}
