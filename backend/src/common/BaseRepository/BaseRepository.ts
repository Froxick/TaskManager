import { PaginationResult } from './BaseRepository.types';

export class BaseRepository<
  T,
  WhereUniqueInput,
  WhereInput,
  CreateInput,
  UpdateInput,
  OrderByInput,
> {
  constructor(
    protected readonly model: {
      findUnique: (args: { where: WhereUniqueInput }) => Promise<T | null>;
      findMany: (args: {
        where?: WhereInput;
        skip?: number;
        take?: number;
        orderBy?: OrderByInput;
      }) => Promise<T[]>;
      create: (args: { data: CreateInput }) => Promise<T>;
      update: (args: {
        where: WhereUniqueInput;
        data: UpdateInput;
      }) => Promise<T>;
      delete: (args: { where: WhereUniqueInput }) => Promise<T>;
      count: (args: { where?: WhereInput }) => Promise<number>;
    },
  ) {}

  async findById(where: WhereUniqueInput): Promise<T | null> {
    return this.model.findUnique({ where });
  }
  async create(data: CreateInput): Promise<T> {
    return this.model.create({ data });
  }

  async update(data: UpdateInput, where: WhereUniqueInput): Promise<T> {
    return this.model.update({ where, data });
  }
  async delete(where: WhereUniqueInput): Promise<T> {
    return this.model.delete({ where });
  }
  async findMany(params: {
    where?: WhereInput;
    page?: number;
    limit?: number;
    orderBy?: OrderByInput;
  }): Promise<PaginationResult<T>> {
    const { where, page = 1, limit = 10, orderBy } = params;

    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
      this.model.findMany({
        where,
        skip,
        take: limit,
        orderBy,
      }),
      this.model.count({ where }),
    ]);
    return {
      data,
      meta: {
        total,
        page,
        limit,
        lastPage: Math.ceil(total / limit),
      },
    };
  }
}
