import pygame

def player(mute, text):
  if mute: return
  pygame.init()
  # mp3 파일 경로
  mp3_file = f'{text}.mp3'

  pygame.mixer.music.load(mp3_file)
  pygame.mixer.music.play()

  # 재생이 끝날 때까지 대기
  while pygame.mixer.music.get_busy():
      pass