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
import { UserService } from './user.service';
import { JwtService } from 'src/jwt/jwt.service';
import { AuthGuard } from 'src/Guards/AuthGuard';
import { UserFilterDto } from './DTO/userFilterDto';
import { UserUpdateDto } from './DTO/userUpdateDto';
import { UserLoginDto } from './DTO/userLoginDto';
import { UserRegisterDto } from './DTO/userRegisterDto';

@Controller('user')
export class UserController {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async getUsers(@Query() filters: UserFilterDto) {
    return await this.userService.getUsers(
      filters.page || 1,
      filters.limit || 10,
      filters.email,
    );
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async getUserById(@Param('id', ParseIntPipe) id: number) {
    return await this.userService.getOneUser(id);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async deleteUser(@Param('id', ParseIntPipe) id: number) {
    return await this.userService.deleteUser(id);
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @UseGuards(AuthGuard)
  async updateUser(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UserUpdateDto,
  ) {
    return await this.userService.updateUser(dto, id);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @UsePipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  )
  async loginUser(@Body() userLoginDto: UserLoginDto) {
    const user = await this.userService.loginUser(userLoginDto);

    const tokens = await this.jwtService.generateTokens({
      email: user.email,
      id: user.id,
      name: user.name,
    });
    return {
      user: user,
      tokens: tokens,
    };
  }

  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @UsePipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  )
  async registerUser(@Body() dto: UserRegisterDto) {
    const user = await this.userService.registerUser(dto);
    const tokens = await this.jwtService.generateTokens({
      email: user.email,
      id: user.id,
      name: user.name,
    });

    return {
      user: user,
      tokens: tokens,
    };
  }
}
