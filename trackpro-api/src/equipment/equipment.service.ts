import { Injectable } from '@nestjs/common';
import { CreateEquipmentDto } from './dto/create-equipment.dto';
import { UpdateEquipmentDto } from './dto/update-equipment.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EquipmentService {
  constructor(private prisma: PrismaService) {}

  create(createEquipmentDto: CreateEquipmentDto) {
    return this.prisma.equipment.create({
      data: createEquipmentDto,
    });
  }

  findAll() {
    return this.prisma.equipment.findMany();
  }

  findOne(id: number) {
    return this.prisma.equipment.findUnique({
      where: { id },
    });
  }

  update(id: number, updateEquipmentDto: UpdateEquipmentDto) {
    return this.prisma.equipment.update({
      where: { id },
      data: updateEquipmentDto,
    });
  }

  remove(id: number) {
    return this.prisma.equipment.delete({
      where: { id },
    });
  }
}
