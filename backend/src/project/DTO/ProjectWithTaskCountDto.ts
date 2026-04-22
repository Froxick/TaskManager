import { Project } from 'generated/prisma/client';

export interface ProjectWithTaskCountDto {
  project: Project;
  totalTasksCount: number;
  completedTasksCount: number;
}
