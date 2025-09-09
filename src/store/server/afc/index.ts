import { Module } from 'vuex'
import { AFCState } from './types'
import { actions } from './actions'
import { mutations } from './mutations'
import { getters } from './getters'

const state: AFCState = {
  lanes: [],
  laneList: [],
  mapList: [],
}

export const afc: Module<AFCState, any> = {
  namespaced: true,
  state,
  actions,
  mutations,
  getters,
}
