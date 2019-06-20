import json
import logging
import os
import uuid

from jsonmerge import merge
from telegram.ext import (Updater, CommandHandler, MessageHandler, Filters, ConversationHandler, PicklePersistence)

# Enable logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)

logger = logging.getLogger(__name__)


# Config file
def update_config(cfg):
    with open('%s/config.json' % working_dir, 'w') as outfile:
        json.dump(cfg, outfile, indent=4, sort_keys=True)


working_dir = os.path.dirname(os.path.realpath(__file__))
with open('%s/config.json.template' % working_dir, 'r+') as base, open('%s/config.json' % working_dir, 'r+') as head:
    config_template = json.load(base)
    current_config = json.load(head)
    config = merge(config_template, current_config)

# Conversation workflow
SET_PIN, SET_LOCATION = range(2)


def start(update, context):
    current_pin = context.user_data.get('pin') or None

    if (current_pin is None) or (int(current_pin) != int(config['telegram']['pin'])):
        update.message.reply_text(
            'Hallo! \nIch bin dein Bilderrahmen 😁 🏞 🎉 \n\n'
            'Bitte schicke mir die aufgedruckte PIN.')
        return SET_PIN
    else:
        update.message.reply_text(
            'Deine PIN wurde bereits erfolgreich gesetzt. Du kannst nun Bilder an mich senden.')
        return ConversationHandler.END


def set_location(update, context):
    user_location = update.message.location
    context.user_data['user_location'] = user_location

    config['location']['lat'] = user_location.latitude
    config['location']['lon'] = user_location.longitude

    update_config(config)

    update.message.reply_text('Damit haben wir alles 😄. Du kannst nun Bilder an mich senden 🙏.')

    return ConversationHandler.END


def set_pin(update, context):
    new_pin = update.message.text
    context.user_data['pin'] = new_pin

    current_location = context.user_data.get('user_location') or None

    if current_location is None:
        update.message.reply_text('Vielen Dank. Deine PIN wurde erfolgreich gesetzt. '
                                  'Als nächstes brauche ich die Position des Bilderrahmens als Standort,'
                                  'um den Farbfilter und Nachtmodus anzupassen 😴.')
        return SET_LOCATION
    else:
        update.message.reply_text('Damit haben wir alles 😄. Du kannst nun Bilder an mich senden 🙏.')
        return ConversationHandler.END


def photo_handler(update, context):
    current_pin = context.user_data.get('pin') or None

    if (current_pin is None) or (int(current_pin) != int(config['telegram']['pin'])):
        update.message.reply_text(
            'Du hast keine PIN gesetzt 😱.\n'
            'Bitte nutze den /start command 🧐.')
    else:
        photo_file = update.message.photo[-1].get_file()
        photo_file.download('%s/../images/%s.jpg' % (working_dir, str(uuid.uuid4())))
        update.message.reply_text('Danke für das Photo 🤩!\n'
                                  'Ich zeige es dir gleich an.')


def error(update, context):
    logger.warning('Update "%s" caused error "%s"', update, context.error)


def cancel():
    return ConversationHandler.END


def main():
    pp = PicklePersistence(filename='%s/../data/conversationbot' % working_dir)
    updater = Updater(str(config['telegram']['bot']['token']), persistence=pp, use_context=True)

    dp = updater.dispatcher

    start_conversation_handler = ConversationHandler(
        entry_points=[CommandHandler('start', start)],
        states={
            SET_PIN: [MessageHandler(Filters.text, set_pin)],
            SET_LOCATION: [MessageHandler(Filters.location, set_location)],
        },
        fallbacks=[CommandHandler('cancel', cancel)]
    )
    dp.add_handler(start_conversation_handler)

    dp.add_handler(MessageHandler(Filters.photo, photo_handler))

    dp.add_error_handler(error)

    updater.start_polling()

    updater.idle()


if __name__ == '__main__':
    main()
