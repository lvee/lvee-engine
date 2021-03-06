module ConferenceRegistrationsHelper

  URL_REGEXP = %r|(.*?://)([^/]+)(/.*)?| #/

  def strip_urls str
    out = []
    return str if str.blank?

    str.split(' ').each do |word|
      if word =~ URL_REGEXP
        out << word.gsub(URL_REGEXP) { "<a class=\"participants_url\" href=\"#{word}\" title=\"#{word}\">#{$1}#{$2}</a>" }
      else
        out << word
      end
    end

    out.join(' ')
  end

#  def as_(param, opts={})
#    t("label.conference_registration.#{param}", :default => t("label.common.#{param}"))
#  end

  def transport_options(type)
    values = TRANSPORT.map do |i|
      [t("label.conference_registration.transport_#{type}_list.#{i}"), i]
    end
    values = [[t("label.common._select_"), ""]] + values
  end

  def floor_form_column(record, input_name)
    content_tag("div", check_box("record", "floor"))
  end

  def days_form_column(record, input_name)
    translated_days = I18n.translate(:'date.day_names')
    end_days = I18n.translate(:'date.day_names', :locale => I18n.default_locale)
    days = translated_days.zip(end_days)
    selectable_days = days[4..-1] + [days[0]]
    @record.days = ""  if @record.days.nil?
    selected_days = @record.days

    days_list = selectable_days.map do |day|
      content_tag(:li,  check_box_tag("record[days][]", day[1], selected_days.include?(day[1]))+  h(day[0]))
    end
    content_tag(:div, content_tag(:ul, days_list.join("\n").html_safe) +
      hidden_field_tag("record[days][]", ""))
  end

  def tshirt_form_column(record, input_name)
    s = ""
    @record.tshirt = "" if @record.tshirt.nil?
    selected_sizes = @record.tshirt.split(',')
    @record.quantity.times do|i|
      s << select_tag("record[tshirt][]", options_for_select(TSHIRT_SIZES, selected_sizes[i]))
    end
    content_tag(:div, s.html_safe)
  end

  def transport_from_form_column(record, input_name)
    select("record", "transport_from",  transport_options(:from))
  end

  def transport_to_form_column(record, input_name)
    select("record", "transport_to",  transport_options(:to))
  end

  def age_options
    values = AGE.map do |i|
      [t("label.conference_registration.age_list.#{i}"), i]
    end
    values = [[t("label.common._select_"), ""]] + values
  end

  def age_form_column(record, input_name)
    select("record", "age",  age_options)
  end

  def position_options
    values = POSITION.map do |i|
      [t("label.conference_registration.position_list.#{i}"), i]
    end
    values = [[t("label.common._select_"), ""]] + values
  end

  def position_form_column(record, input_name)
    select("record", "position",  position_options)
  end

  def known_conf_options
    values = KNOWN.map do |i|
      [t("label.conference_registration.known_conf.#{i}"), i]
    end
    values = [[t("label.common._select_"), ""]] + values
  end

  def known_conf_form_column(record, input_name)
    select("record", "known_conf",  known_conf_options)
  end

end
