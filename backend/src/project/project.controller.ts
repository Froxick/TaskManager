import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { ProjectService } from './project.service';
import { AuthGuard } from 'src/Guards/AuthGuard';
import { ProjectCreateDto } from './DTO/ProjectCreateDto';
import { ProjectUpdateDto } from './DTO/ProjectUpdateDto';
import { ProjectFilterDto } from './DTO/ProjectFilterDto';

@Controller('project')
export class ProjectController {
  constructor(private readonly service: ProjectService) {}

  @Get(':userId')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async getUserProjects(
    @Param('userId', ParseIntPipe) userId: number,
    @Query() filters: ProjectFilterDto,
  ) {
    return await this.service.getProjectsByUserId(
      userId,
      filters.isCompleted || false,
      filters.isArchived || false,
    );
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @UseGuards(AuthGuard)
  @UsePipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  )
  async createProject(@Body() createDto: ProjectCreateDto) {
    return await this.service.createNewProject(createDto);
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async updateProject(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: ProjectUpdateDto,
  ) {
    return await this.service.updateProject(dto, id);
  }

  @Patch('status/:id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async updateStatus(
    @Param('id', ParseIntPipe) id: number,
    @Body() userId: number,
  ) {
    return await this.service.updateStatus(id, userId);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async archivedProject(
    @Param('id', ParseIntPipe) id: number,
    @Query('userId') userId: number,
  ) {
    return await this.service.archivedProject(id, userId);
  }
}
