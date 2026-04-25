/* eslint-disable no-useless-catch */
import { Injectable } from '@nestjs/common';
import { TaskRepository } from './task.repository';
import { TaskFilterDto } from './DTO/taskFilterDto';
import { AppException } from 'src/common/exceptions/app.exception';
import { TaskCreateDto } from './DTO/taskCreateDto';
import { TaskUpdateDto } from './DTO/taskUpdateDto';

@Injectable()
export class TaskService {
  constructor(private readonly repository: TaskRepository) {}

  async getTaskByProjectId(
    projectId: number,
    filters: TaskFilterDto,
    userId: number,
  ) {
    try {
      return await this.repository.getTasks(projectId, filters, userId);
    } catch (e) {
      throw e;
    }
  }

  async setTimer(taskId: number, userId: number, status: 'stop' | 'start') {
    try {
      if (status === 'start') {
        const findTask = await this.repository.findById({
          id: taskId,
        });
        if (findTask?.isTimerRunning === true) {
          throw new AppException('Таймер уже запущен', 400);
        }
        return await this.repository.startTimer(taskId, userId);
      } else if (status === 'stop') {
        const findTask = await this.repository.findById({
          id: taskId,
        });
        if (findTask?.isTimerRunning !== true) {
          throw new AppException('Таймер не запущен', 400);
        }
        return await this.repository.startTimer(taskId, userId);
      }
    } catch (e) {
      throw e;
    }
  }

  async createTask(dto: TaskCreateDto, userId: number) {
    await this.validUser(userId, dto.projectId);
    return await this.repository.create({
      title: dto.title,
      project: {
        connect: { id: dto.projectId },
      },
      deadLine: dto.deadLine,
      description: dto.description,
      difficulty: dto.difficulty,
      status: dto.status,
      estimatedHours: dto.estimatedHours,
    });
  }
  async updateTask(taskId: number, dto: TaskUpdateDto, userId: number) {
    try {
      return await this.repository.update(dto, {
        id: taskId,
        project: {
          userId: userId,
        },
      });
    } catch (e) {
      throw e;
    }
  }
  async deleteTask(taskId: number, userId: number) {
    try {
      return await this.repository.delete({
        id: taskId,
        project: {
          userId: userId,
        },
      });
    } catch (e) {
      throw e;
    }
  }

  private async validUser(userId: number, projectId: number) {
    try {
      const findProject = await this.repository.findProject(projectId);
      if (!findProject) {
        throw new AppException('Ошибка досупа', 404);
      }
      if (findProject.userId !== userId) {
        throw new AppException('Ошибка доступа', 403);
      }
    } catch (e) {
      throw e;
    }
  }
}
