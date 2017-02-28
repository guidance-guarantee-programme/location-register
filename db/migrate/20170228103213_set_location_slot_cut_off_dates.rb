class SetLocationSlotCutOffDates < ActiveRecord::Migration[5.0]
  def up
    locations_to_close = %w(
      01564919-9cf2-43ed-ac2a-91a33e5e81ea
      2044b7e6-c819-43a8-8c3f-f239c9a28aa6
      77d003f9-976d-4eb2-8703-715b698b96d4
      ddc5113c-fb17-4cdb-be0e-76900446fb14
      d38d399a-db2b-49cd-b50a-1804f02b52de
      c481d0a6-dccb-4f52-bfa0-57aba00a2560
      266ba3bc-768d-4184-a79f-104277e87b08
      271e70b9-27b0-4c56-910b-feca5530a3a0
      888dacac-fdbd-4ce6-9344-396b380567ea
      df2361e6-e17f-4448-a8b4-7214d7b8bd43
      49d362a8-e36e-4f88-b41f-6b982566b7d6
      7f1acc30-8a35-48d2-aed0-64ab745ec079
      6a5ac806-6476-4fd2-9c08-87a6a100b359
      585473d8-6227-45f1-aa7d-dc01bbe8db7b
      ce33c3ba-0dbc-452d-85eb-fd96d759431c
      2fd87784-c67f-44dc-87f0-615412a731f0
      872068bf-f521-4b3b-a7b5-dd834422854e
      91ec2400-7653-44a7-b218-16722a939a23
      5e26a381-eedd-413e-b30e-4c05528efaec
    ).freeze

    Location.current.active.where(uid: locations_to_close).update_all(cut_off_from: '2017-04-01')
  end

  def down
    # noop
  end
end
