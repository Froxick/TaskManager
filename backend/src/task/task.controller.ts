import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { TaskService } from './task.service';
import { AuthGuard } from 'src/Guards/AuthGuard';
import { TaskFilterDto } from './DTO/taskFilterDto';
import { JwtData } from 'src/jwt/jwt.data';
import { TaskCreateDto } from './DTO/taskCreateDto';
import { TaskUpdateDto } from './DTO/taskUpdateDto';

@Controller('task')
export class TaskController {
  constructor(private readonly service: TaskService) {}

  @Get(':projectId')
  @UseGuards(AuthGuard)
  async getTasks(
    @Param('projectId', ParseIntPipe) projectId: number,
    @Query() filters: TaskFilterDto,
    @Req()
    req: {
      user: JwtData;
    },
  ) {
    const userId = req.user.id;
    return await this.service.getTaskByProjectId(projectId, filters, userId);
  }
  @Post()
  @UseGuards(AuthGuard)
  async createTask(@Body() dto: TaskCreateDto, @Req() req: { user: JwtData }) {
    return await this.service.createTask(dto, req.user.id);
  }
  @Patch(':id')
  @UseGuards(AuthGuard)
  async updateTask(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: TaskUpdateDto,
    @Req() req: { user: JwtData },
  ) {
    return await this.service.updateTask(id, dto, req.user.id);
  }
  @Delete(':id')
  @UseGuards(AuthGuard)
  async deleteTask(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: { user: JwtData },
  ) {
    return await this.service.deleteTask(id, req.user.id);
  }

  @Patch('timer/start/:id')
  @UseGuards(AuthGuard)
  async startTimer(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: { user: JwtData },
  ) {
    return await this.service.setTimer(id, req.user.id, 'start');
  }

  @Patch('timer/stop/:id')
  @UseGuards(AuthGuard)
  async stopTimer(
    @Param('id', ParseIntPipe) id: number,
    @Req() req: { user: JwtData },
  ) {
    return await this.service.setTimer(id, req.user.id, 'stop');
  }
}
