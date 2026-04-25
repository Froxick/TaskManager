import {
  IsInt,
  IsOptional,
  IsString,
  IsEnum,
  IsDateString,
} from 'class-validator';
import { TaskStatus } from 'generated/prisma/client';

export class TaskCreateDto {
  @IsInt()
  projectId: number;

  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsInt()
  difficulty: number;

  @IsDateString()
  deadLine: string;

  @IsOptional()
  @IsEnum(TaskStatus)
  status?: TaskStatus;

  @IsOptional()
  estimatedHours?: number;
}
