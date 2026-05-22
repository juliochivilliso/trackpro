const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding data...');

  // Drivers
  await prisma.driver.createMany({
    data: [
      { firstName: 'Juan', lastName: 'Pérez', licenseNumber: 'DL-12345' },
      { firstName: 'María', lastName: 'Rodríguez', licenseNumber: 'DL-67890' },
    ],
  });

  // Equipment
  await prisma.equipment.createMany({
    data: [
      { code: 'GPS-001', name: 'Teltonika FMB920', imei: '123456789012345', status: 'AVAILABLE' },
      { code: 'GPS-002', name: 'Queclink GV300', imei: '987654321098765', status: 'AVAILABLE' },
      { code: 'GPS-003', name: 'Coban TK103', imei: '111222333444555', status: 'AVAILABLE' },
    ],
  });

  console.log('Seeding complete.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
