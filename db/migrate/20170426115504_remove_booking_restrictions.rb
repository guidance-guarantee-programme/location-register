class RemoveBookingRestrictions < ActiveRecord::Migration[5.0]
  def up
    locations = %w(
      26c38b1b-59e3-4c52-9390-ef3b644dd60a
      18ef0b7d-b13a-4284-9765-aa888aa4ba09
      36ab7bd7-87e2-47d6-8ffc-edd7e5264380
      49641b3a-19f9-4838-85f5-efa4b30676b8
      3af63faf-0e86-48f7-a00d-8e74216d49f7
      b55df4eb-5461-4350-86fd-9945f4444bec
      a4c87f83-000b-4fcf-9282-6b6241f9d44b
      585473d8-6227-45f1-aa7d-dc01bbe8db7b
      846085a7-4c52-4a2d-a20f-0546bc5d5684
      50d99366-9a77-4fe6-afac-8e63d96b289f
      b6ee74b7-4562-4fb2-8e9d-cca5d42fe567
      6a5ac806-6476-4fd2-9c08-87a6a100b359
      1812446c-77a1-462f-b356-a13b3c203658
      1dd4fe43-a0ca-4468-b7a3-d78b8d8501a1
      c751d1c7-39a2-46d9-ab10-ff5a57060fe9
      d0a6ac30-8f8d-4cf1-8cd0-4db27f104502
      b4aa9b5f-2a68-4668-a715-a1e78614a613
      0b703eb5-64fa-44b5-85e0-fa378392ba55
      ab13c300-c2dc-4802-a929-148102cbdace
      15fd41b2-439a-448a-b775-b2b61e16d4bb
      ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef
      1cc67bbb-b879-4def-8713-99255a0bce03
      c165d25e-f27b-4ce9-b3d3-e7415ebaa93c
      89821b79-b132-4893-bc9f-c247dd9009fd
      1a1ad00f-d967-448a-a4a6-772369fa5087
      d076ede9-5c36-49a4-879c-d8924792583f
      123015e5-bb23-4690-ad41-99e12c381392
      209b2f4d-5696-46ab-a4ec-65839acd0744
      068af268-515f-47ba-9ef6-dea129b5413d
      6cdd30bf-c736-4f5a-a780-4afd0cf2c361
      8e0e385f-2ec9-4e4f-b38e-63ca22d2ac1a
      fd9fdeff-d3e2-4fb8-a20a-38a4381fdfef
      04893a8d-d145-4b62-aaee-7db8d7106a12
      28c7fac1-4c6d-4444-b30f-e3711eedd9b0
      f47c08e1-9322-4730-9059-c3aa97f49cf4
      7c00741c-0f7c-436d-ad27-1a503693192e
      ee399dec-f9c2-4201-b27f-e3da114d3e17
      27a9ea16-a86e-4d59-a15a-7a2999d383fd
      c02201b3-cc4e-4ef2-9183-7eb704287303
      1adae53b-5ce3-47ab-a7c3-24393c7f7f1a
      41214e8d-9dfc-4f2f-9e58-8bf08c51001c
      886a161a-41ca-4366-9b51-75ce94aa23fb
      bd464be9-8b9f-4a55-b3ef-a4a8f16ed41d
      c8a52d5a-4136-4c0f-b7f2-4277cfb8c249
      184fcd75-7196-4be3-8541-bf2adad929d2
      a371284c-681f-4da5-9d4f-c3f6b24620b3
      f91ee9b9-2253-42d7-a505-586b66aed41a
      ddfe1168-abbf-461d-b5ea-1ce6c63ee4cf
      709ffeec-9059-4e25-89b7-5db04d3cf79c
      8ffb927e-ceea-4db7-a373-a9f335428b8b
      a75c52c0-7b36-42b5-b965-73c8949c252d
      e8fa2ad0-9b45-418e-93ef-120c79cdb487
      d9b55e78-2c11-44e3-a203-76c11070e334
      52747945-8f8a-4766-b397-e19f765a58db
      fef02333-6563-4643-b4dd-68224090d395
      7b6f6842-8a82-4993-ba0c-3b7e080b3e05
      04c29b5f-a199-4acd-a2d7-5369ff9a52f2
      18ef0b7d-b13a-4284-9765-aa888aa4ba09
      b5948a66-34fa-44f9-9c62-641eb2cf501b
      36ab7bd7-87e2-47d6-8ffc-edd7e5264380
      e5e91152-3956-4860-8b4c-cd0620a1215d
      49641b3a-19f9-4838-85f5-efa4b30676b8
    ).freeze

    Location
      .current
      .where(uid: locations)
      .update_all(cut_off_from: nil)
  end

  def down
    # noop
  end
end
