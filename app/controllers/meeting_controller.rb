class MeetingController < ApplicationController
  FIRST_NAME = 0
  LAST_NAME = 1
  DEPARTMENT = 2
  PRESENCE = 3

  def index
  end

  def randomize
    @pre_meeting_sheet = params[:pre_meeting_sheet]
    @meeting_pairs = make_pairs(@pre_meeting_sheet)
    render 'index'
  end

  private

  def make_pairs(pre_meeting_sheet)
    # parse and remove headers
    pairs = CSV.parse(pre_meeting_sheet, col_sep: "\t")[1..-1].
      # pick only available people
      select{|x| x[PRESENCE] == 'Around'}

    return 'You need at least 2 people to make a pair' if pairs.count < 2

    pairs = pairs.
      # collapse columns into single string: "firstname secondname (department)
      map{|x| "#{x[FIRST_NAME]} #{x[LAST_NAME]} (#{x[DEPARTMENT]})"}.
      # randomize
      sort.
      shuffle.
      # convert into array of pairs
      each_slice(2).
      to_a

    # if last element contains a single person, make previous element a trio
    if pairs[-1].count == 1
      pairs[-2] << pairs[-1][0]
      pairs.pop
    end

    # combine each array of pairs into a single string separated with "and"
    pairs.map{|x| x.join(' and ')}.join("\n")
  end
end
