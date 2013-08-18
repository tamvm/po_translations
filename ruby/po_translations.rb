require 'get_pomo'
require "debugger"
require "active_support/core_ext"

SRC_PATH = File.expand_path(File.dirname(__FILE__))
ROOT_PATH = File.expand_path(SRC_PATH + "./..")
require File.expand_path(File.join(SRC_PATH, "google_translator.rb"))

ignore_files = ["456market.po", "option-tree.po", "theme.po", "tinymce.po"]
Dir[File.join(ROOT_PATH, "data/*.po")].each do |file_path|
  next if ignore_files.include? File.basename(file_path)

  puts "--- #{file_path}"
  translations = GetPomo::PoFile.parse(File.read(file_path))
  translations.each_with_index do |translation, index|
    next if translation.msgid.blank?
    translation.msgstr = GoogleTranslator.translate(translation.msgid)
    if index % 20 == 0
      puts index
      sleep 3
    end
  end

  File.write(File.join(ROOT_PATH, "data/translated", File.basename(file_path)), GetPomo::PoFile.to_text(translations))
end

