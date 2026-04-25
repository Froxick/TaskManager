import { IsOptional, IsEnum, IsIn } from 'class-validator';
import { TaskStatus } from 'generated/prisma/client';

export class TaskFilterDto {
  @IsOptional()
  @IsEnum(TaskStatus)
  status?: TaskStatus;

  @IsOptional()
  @IsIn(['difficulty', 'deadLine', 'actualHours'])
  sortBy?: 'difficulty' | 'deadLine' | 'actualHours';

  @IsOptional()
  @IsIn(['asc', 'desc'])
  order?: 'asc' | 'desc';
}
