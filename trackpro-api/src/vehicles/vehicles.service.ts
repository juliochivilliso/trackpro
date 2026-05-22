import { Injectable } from '@nestjs/common';
import { CreateVehicleDto } from './dto/create-vehicle.dto';
import { UpdateVehicleDto } from './dto/update-vehicle.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class VehiclesService {
  constructor(private prisma: PrismaService) {}

  create(createVehicleDto: CreateVehicleDto) {
    return this.prisma.vehicle.create({
      data: createVehicleDto,
    });
  }

  findAll() {
    return this.prisma.vehicle.findMany({
      where: { isActive: true },
      include: {
        assignments: {
          where: { isActive: true },
          include: {
            equipment: true,
            driver: true,
          },
        },
      },
    });
  }

  findOne(id: number) {
    return this.prisma.vehicle.findUnique({
      where: { id },
      include: {
        assignments: {
          include: {
            equipment: true,
            driver: true,
          },
        },
      },
    });
  }

  update(id: number, updateVehicleDto: UpdateVehicleDto) {
    return this.prisma.vehicle.update({
      where: { id },
      data: updateVehicleDto,
    });
  }

  remove(id: number) {
    return this.prisma.vehicle.update({
      where: { id },
      data: { isActive: false },
    });
  }
}
