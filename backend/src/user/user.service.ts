/* eslint-disable no-useless-catch */
import { Injectable } from '@nestjs/common';
import { UserRepository } from './userRepository';
import { ConfigService } from '@nestjs/config';
import { AppException } from 'src/common/exceptions/app.exception';
import { UserRegisterDto } from './DTO/userRegisterDto';

import { UserLoginDto } from './DTO/userLoginDto';
import { IUserResponse } from './DTO/userRepsonseInterface';
import { UserEntity } from './userEntity';
import { Prisma, User } from 'generated/prisma/client';
import { UserUpdateDto } from './DTO/userUpdateDto';

@Injectable()
export class UserService {
  constructor(
    private readonly repository: UserRepository,
    private readonly configService: ConfigService,
  ) {}
  async getOneUser(id: number) {
    try {
      const findUser = await this.repository.findById({ id });
      if (!findUser)
        throw new AppException('Пользователь не найден', 404, 'USER_NOT_FOUND');
      return findUser;
    } catch (e) {
      throw e;
    }
  }
  async getProfile(id: number) {
    try {
      const findUser = await this.repository.findById({ id });
      if (!findUser)
        throw new AppException('Пользователь не найден', 404, 'USER_NOT_FOUND');
      return {
        name: findUser.name,
        email: findUser.email,
        id: findUser.id,
      };
    } catch (e) {
      throw e;
    }
  }
  async getUsers(page: number, limit: number, email?: string) {
    const where: Prisma.UserWhereInput = {};
    if (email) {
      where.email = {
        contains: email,
        mode: 'insensitive',
      };
    }

    const users = await this.repository.findMany({ where, page, limit });
    const userData = users.data.map((el) => this.helperType(el));
    return {
      users: {
        meta: users.meta,
        data: userData,
      },
    };
  }

  async loginUser(dto: UserLoginDto) {
    try {
      const findUser = await this.repository.findByEmail(dto.email);
      if (!findUser) {
        throw new AppException('Пользователь не найден', 404, 'USER_NOT_FOUND');
      }
      const user = new UserEntity(
        findUser.email,
        findUser.name,
        findUser.password,
      );
      if (!(await user.validPassword(dto.password))) {
        throw new AppException('Неверная почта или пароль', 401);
      }
      return this.helperType(findUser);
    } catch (e) {
      throw e;
    }
  }

  async registerUser(dto: UserRegisterDto) {
    try {
      const findUser = await this.repository.findByEmail(dto.email);
      if (findUser) {
        throw new AppException('Пользователь уже существует', 409);
      }
      const user = new UserEntity(dto.email, dto.name);
      console.log(user, 'user');
      const salt = this.configService.get<string>('SALT');
      console.log(salt, 'salt');
      await user.setPassword(dto.password, Number(salt));
      console.log(user.password);
      const newUser = await this.repository.create({
        email: user.email,
        name: user.name,
        password: user.password,
      });
      return newUser;
    } catch (e) {
      throw e;
    }
  }

  async deleteUser(id: number) {
    try {
      const findUser = await this.repository.findById({ id });
      if (!findUser) {
        throw new AppException('Пользователь не найден', 404);
      }
      await this.repository.delete({
        id: id,
      });
    } catch (e) {
      throw e;
    }
  }

  async updateUser(dto: UserUpdateDto, id: number) {
    try {
      const findUser = await this.repository.findById({ id });
      if (!findUser) {
        throw new AppException('Пользователь не найден', 404);
      }
      const updatedUser = await this.repository.update(dto, {
        id: id,
      });
      return updatedUser;
    } catch (e) {
      throw e;
    }
  }

  private helperType(user: User): IUserResponse {
    return {
      id: user.id,
      email: user.email,
      name: user.name,
    };
  }
}
