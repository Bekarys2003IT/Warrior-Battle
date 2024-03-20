import asyncio
import logging

import requests
from aiogram import Bot, Dispatcher, types
from aiogram.filters import CommandStart
from googleapiclient.discovery import build

# Set up logging
logging.basicConfig(level=logging.INFO)

# Initialize the bot and dispatcher
TELEGRAM_TOKEN = '6896622097:AAGEweurOEWCU5Tq3LhHC2GtCbt6ETsWO40'
bot = Bot(token=TELEGRAM_TOKEN)
dp = Dispatcher()

# Initialize the Google Cloud AI client
# GOOGLE_API_KEY = 'AIzaSyAOt7hzz8l5sG7i67egUPxrpmDSNBI77_o'
GOOGLE_API_KEY = 'AIzaSyCR6-kgHKbRgyKHXbQj-HgbhHAdtKMEv9w'
SERVICE_NAME = 'language'  # Adjust based on the service you're using, e.g., 'language', 'vision', etc.
VERSION = 'v1'
client = build(SERVICE_NAME, VERSION, developerKey=GOOGLE_API_KEY)


# Function to call Google Cloud AI service
async def predict(text):
    # Call the appropriate API method here
    # For example, if using the Natural Language API for sentiment analysis:
    try:
        request = requests.post(
            f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key={GOOGLE_API_KEY}",
        json={"contents":[{"parts":[{"text":text}]}]})
        response = request.json()
        # print(response)
        return response.get('candidates')[0].get('content').get('parts')[0].get('text')
    except Exception as e:
        return "Can not answer to that question now. Try again later"


@dp.message(CommandStart())
async def start_command(message: types.Message):
    await message.answer("Иди в жопу")


# Handler for text messages
@dp.message()
async def echo_message(message: types.Message):
    user_message = message.text

    # Get prediction from Google Cloud AI
    answer_message = await message.answer("Wait for answer...")
    bot_message = await predict(user_message)

    # Reply with the sentiment analysis result
    await answer_message.edit_text(bot_message)


async def main():
    await dp.start_polling(bot)


# Start the bot
if __name__ == '__main__':
    asyncio.run(main())
