import {
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
  Req,
  ParseFilePipe,
  MaxFileSizeValidator,
  FileTypeValidator,
  UseGuards,
  Get,
  Query,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('search')
  async search(@Query('q') query: string, @Req() req: any) {
    if (!query || query.length < 2) return [];
    return this.usersService.search(query, req.user.userId);
  }

  @Post('avatar')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: './public/uploads/avatars',
        filename: (req, file, cb) => {
          const randomName = Array(32)
            .fill(null)
            .map(() => Math.round(Math.random() * 16).toString(16))
            .join('');
          return cb(null, `${randomName}${extname(file.originalname)}`);
        },
      }),
    }),
  )
  async uploadAvatar(
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({ maxSize: 2 * 1024 * 1024 }), // 2MB
          new FileTypeValidator({ fileType: /.(png|jpeg|jpg)/ }),
        ],
      }),
    )
    file: any,
    @Req() req: any,
  ) {
    // We already have a static route for /public serving at /test-client
    // so maybe I should add another for /uploads or just change it.
    // Let's use /uploads prefix.
    const avatarUrl = `/uploads/${file.filename}`;
    await this.usersService.update(req.user.userId, { avatarUrl });
    return { avatarUrl };
  }
}
