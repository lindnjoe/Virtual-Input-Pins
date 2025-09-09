export interface Lane {
  name: string
  map: string
  tool_loaded: boolean
}

export interface AFCState {
  lanes: Lane[]
  laneList: string[]
  mapList: string[]
}
