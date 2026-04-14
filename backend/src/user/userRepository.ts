import { Injectable } from '@nestjs/common';
import { Prisma, User } from 'generated/prisma/client';
import { BaseRepository } from 'src/common/BaseRepository/BaseRepository';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class UserRepository extends BaseRepository<
  User,
  Prisma.UserWhereUniqueInput,
  Prisma.UserWhereInput,
  Prisma.UserCreateInput,
  Prisma.UserUpdateInput,
  Prisma.UserOrderByWithRelationInput
> {
  constructor(private prisma: PrismaService) {
    super(prisma.user);
  }
  async findByEmail(email: string) {
    return await this.prisma.user.findUnique({
      where: { email: email },
    });
  }
}
