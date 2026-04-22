import { Injectable } from '@nestjs/common';
import { Prisma, Project, TaskStatus } from 'generated/prisma/client';
import { BaseRepository } from 'src/common/BaseRepository/BaseRepository';
import { PrismaService } from 'src/prisma/prisma.service';
import { ProjectWithTaskCountDto } from './DTO/ProjectWithTaskCountDto';

@Injectable()
export class ProjectRepository extends BaseRepository<
  Project,
  Prisma.ProjectWhereUniqueInput,
  Prisma.ProjectWhereInput,
  Prisma.ProjectCreateInput,
  Prisma.ProjectUpdateInput,
  Prisma.ProjectOrderByWithRelationInput
> {
  constructor(private prisma: PrismaService) {
    super(prisma.project);
  }

  async getProjectsNoPagination(
    userId: number,
    isCompleted: boolean,
    isArchived: boolean,
  ): Promise<ProjectWithTaskCountDto[]> {
    const findProjects = await this.prisma.project.findMany({
      where: {
        userId,
        isArchived,
        isCompleted,
      },
      include: {
        _count: {
          select: {
            tasks: true,
          },
        },
      },
    });
    const projectIds = findProjects.map((p) => p.id);
    const completedCounts = await this.prisma.task.groupBy({
      by: ['projectId'],
      where: {
        projectId: { in: projectIds },
        status: TaskStatus.COMPLETED,
      },
      _count: {
        status: true,
      },
    });
    const completedCountMap = new Map(
      completedCounts.map((item) => [item.projectId, item._count.status]),
    );
    const projects: ProjectWithTaskCountDto[] = findProjects.map((project) => ({
      project: project,
      totalTasksCount: project._count.tasks,
      completedTasksCount: completedCountMap.get(project.id) || 0,
    }));
    return projects;
  }
}
