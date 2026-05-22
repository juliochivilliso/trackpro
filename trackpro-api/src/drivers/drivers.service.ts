import { Injectable } from '@nestjs/common';
import { CreateDriverDto } from './dto/create-driver.dto';
import { UpdateDriverDto } from './dto/update-driver.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DriversService {
  constructor(private prisma: PrismaService) {}

  create(createDriverDto: CreateDriverDto) {
    return this.prisma.driver.create({
      data: createDriverDto,
    });
  }

  findAll() {
    return this.prisma.driver.findMany({
      where: { isActive: true },
    });
  }

  findOne(id: number) {
    return this.prisma.driver.findUnique({
      where: { id },
    });
  }

  update(id: number, updateDriverDto: UpdateDriverDto) {
    return this.prisma.driver.update({
      where: { id },
      data: updateDriverDto,
    });
  }

  remove(id: number) {
    return this.prisma.driver.update({
      where: { id },
      data: { isActive: false },
    });
  }
}
