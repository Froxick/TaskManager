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
  Req,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { ProjectService } from './project.service';
import { AuthGuard } from 'src/Guards/AuthGuard';
import { ProjectCreateDto } from './DTO/ProjectCreateDto';
import { ProjectUpdateDto } from './DTO/ProjectUpdateDto';
import { ProjectFilterDto } from './DTO/ProjectFilterDto';
import { JwtData } from 'src/jwt/jwt.data';

@Controller('project')
export class ProjectController {
  constructor(private readonly service: ProjectService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async getUserProjects(
    @Req() req: { user: JwtData },
    // @Param('userId', ParseIntPipe) userId: number,
    @Query() filters: ProjectFilterDto,
  ) {
    return await this.service.getProjectsByUserId(
      req.user.id,
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
  async createProject(
    @Body() createDto: ProjectCreateDto,
    @Req() req: { user: JwtData },
  ) {
    return await this.service.createNewProject(createDto, req.user.id);
  }

  @Patch(':projectId')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async updateProject(
    @Param('projectId', ParseIntPipe) projectId: number,
    @Req() req: { user: JwtData },
    @Body() dto: ProjectUpdateDto,
  ) {
    return await this.service.updateProject(dto, projectId, req.user.id);
  }

  @Patch('status/:id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async updateStatus(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: { user: JwtData },
  ) {
    return await this.service.updateStatus(id, req.user.id);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async archivedProject(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: { user: JwtData },
  ) {
    return await this.service.archivedProject(id, req.user.id);
  }
}
