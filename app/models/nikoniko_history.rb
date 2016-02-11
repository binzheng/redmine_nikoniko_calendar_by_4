# Niko-niko Calendar plugin for Redmine 2.X
# Copyright (C) 2013 piccagliani
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
class NikonikoHistory < ActiveRecord::Base
  unloadable

  belongs_to :user
  def self.find_with_project_and_member(project_id, start_date, end_date, roles)
    condition = "`projects`.`identifier` = :project_id and :start_date <= nikoniko_histories.date and nikoniko_histories.date <= :end_date"
    binds = {
      :project_id => project_id,
      :start_date => start_date.to_s,
      :end_date => end_date.to_s
    }

    if roles != nil
      condition += " and member_roles.role_id in(:role_ids)"
      binds[:role_ids] = roles
    end

    self.joins(:user => {:members => [:project,:member_roles]}).where([condition, binds]).order(:user_id,:date)
  end
  def self.get_average_for_user(user_id, start_date, end_date)
    result = self.where(
                 ["niko != 0 AND user_id = :user_id AND :start_date <= date AND date <= :end_date", {
	 	 :user_id => user_id,
	 	 :start_date => start_date.to_s,
	 	 :end_date => end_date.to_s
	       }]).average(:niko)
    average = result == nil ? 0.0 : (result / 3.0 * 1000).round / 10.0
  end

  def self.get_summary_for_user(user_id, start_date, end_date)
    result = self.where(
      ["user_id = :user_id AND :start_date <= date AND date <= :end_date", {
	:user_id => User.current.id,
	:start_date => start_date.to_s,
	:end_date => end_date.to_s
      }]).group(:niko).count(:id)
    days_of_term = (end_date - start_date).to_i + 1 
    total_count = 0
    summary = {"0" => 0, "1" => 0, "2" => 0, "3" => 0}
    result.each do |tmp|
      logger.debug(tmp[0])
      logger.debug(tmp[1])
      summary[tmp[0]] = tmp[1]
      total_count += tmp.count
    end
    summary["0"] += days_of_term - total_count if total_count < days_of_term
    return summary
  end
end
