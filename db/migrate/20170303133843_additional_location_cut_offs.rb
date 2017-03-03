class AdditionalLocationCutOffs < ActiveRecord::Migration[5.0]
  def up
    locations_to_close = %w(
      be6781f2-9d3a-4683-89c4-8c58f39930c0
      6a496a82-9f2a-448d-a785-2522327687f0
      657a523b-f14f-46b9-9024-5b51ddcf1e8e
      26c38b1b-59e3-4c52-9390-ef3b644dd60a
      d1695069-0eb2-409c-bcb1-1d8d176c92bc
      5623d4d2-45be-4e65-8b31-382959c8999f
      18ef0b7d-b13a-4284-9765-aa888aa4ba09
      36ab7bd7-87e2-47d6-8ffc-edd7e5264380
      ca3ac388-8713-41f3-a534-ae1677d5e352
      49641b3a-19f9-4838-85f5-efa4b30676b8
      cff8e53d-4b0c-4f85-ada4-86b2e0e0706b
      2bf14fba-de12-42b2-bea2-769e42385ef1
      3af63faf-0e86-48f7-a00d-8e74216d49f7
      b55df4eb-5461-4350-86fd-9945f4444bec
      a4c87f83-000b-4fcf-9282-6b6241f9d44b
      18c433f7-2359-4485-8a85-61d2e5f3ccfc
      0540b4ed-b7dd-48f0-8a2e-011fa19fcedf
      846085a7-4c52-4a2d-a20f-0546bc5d5684
      72220cc4-3e11-41b4-bcdb-96bb001a751e
      1610e998-4353-4c34-94dc-d2478b4ecd4f
      7047c799-98bd-4785-b0ab-ec5db4534d75
      5f9d8ea1-fd4d-44ed-aa7b-54aa0973bc53
      50d99366-9a77-4fe6-afac-8e63d96b289f
      b6ee74b7-4562-4fb2-8e9d-cca5d42fe567
      bfaf223d-c88f-4a5a-95ed-ebeadbeb5ffc
      b74377da-d06b-48d0-9d74-cc362bbb53b3
      34da8c77-39ce-43b6-88bf-7029803525f0
      e82acef5-154c-4fc9-ba0b-be00ca074d08
      7d87be09-330d-4e40-bd30-7def36da59f9
      2e2a0a97-8a53-46a9-97a3-f7d68bf82997
    ).freeze

    Location.current.active.where(uid: locations_to_close).update_all(cut_off_from: '2017-04-01')
  end

  def down
    # noop
  end
end
