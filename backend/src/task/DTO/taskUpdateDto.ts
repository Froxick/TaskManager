import {
  IsOptional,
  IsString,
  IsEnum,
  IsInt,
  IsDateString,
} from 'class-validator';
import { TaskStatus } from 'generated/prisma/client';

export class TaskUpdateDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsInt()
  difficulty?: number;

  @IsOptional()
  @IsDateString()
  deadLine?: string;

  @IsOptional()
  @IsEnum(TaskStatus)
  status?: TaskStatus;

  @IsOptional()
  estimatedHours?: number;
}
