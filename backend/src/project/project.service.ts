/* eslint-disable no-useless-catch */
import { Injectable } from '@nestjs/common';
import { ProjectRepository } from './project.repository';
import { ProjectCreateDto } from './DTO/ProjectCreateDto';
import { ProjectUpdateDto } from './DTO/ProjectUpdateDto';
import { AppException } from 'src/common/exceptions/app.exception';

@Injectable()
export class ProjectService {
  constructor(private readonly repository: ProjectRepository) {}

  async getProjectsByUserId(
    userId: number,
    isCompleted: boolean,
    isArchived: boolean,
  ) {
    try {
      const findProjects = await this.repository.getProjectsNoPagination(
        userId,
        isCompleted,
        isArchived,
      );
      return findProjects;
    } catch (e) {
      throw e;
    }
  }

  async createNewProject(dto: ProjectCreateDto) {
    try {
      return await this.repository.create({
        name: dto.name,
        description: dto.description,
        user: {
          connect: { id: dto.userId },
        },
      });
    } catch (e) {
      throw e;
    }
  }
  async updateProject(dto: ProjectUpdateDto, projectId: number) {
    try {
      await this.checkUser(dto.userId, projectId);

      const updatetProject = await this.repository.update(
        {
          name: dto.name,
          description: dto.description,
        },
        {
          id: projectId,
        },
      );
      return updatetProject;
    } catch (e) {
      throw e;
    }
  }

  async updateStatus(id: number, userId: number) {
    try {
      await this.checkUser(userId, id);
      const findProject = await this.repository.findById({
        id: id,
      });
      if (!findProject) {
        if (!findProject) {
          throw new AppException('Проект не найден', 404);
        }
      }
      return await this.repository.update(
        {
          isCompleted: !findProject.isCompleted,
        },
        {
          id,
        },
      );
    } catch (e) {
      throw e;
    }
  }
  async archivedProject(id: number, userId: number) {
    try {
      await this.checkUser(userId, id);
      const findProject = await this.repository.findById({
        id,
      });
      if (!findProject) {
        if (!findProject) {
          throw new AppException('Проект не найден', 404);
        }
      }
      return await this.repository.update(
        {
          isArchived: !findProject.isArchived,
        },
        {
          id,
        },
      );
    } catch (e) {
      throw e;
    }
  }

  private async checkUser(userId: number, projectId: number): Promise<void> {
    try {
      const findProject = await this.repository.findById({
        id: projectId,
      });
      if (!findProject) {
        throw new AppException('Проект не найден', 404);
      }
      if (findProject.userId !== userId) {
        throw new AppException('Недостаточно прав', 403);
      }
    } catch (e) {
      throw e;
    }
  }
}
