using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Camera_target : MonoBehaviour {

	private Transform player;


	// Use this for initialization
	void Start () {

		player = GameObject.FindGameObjectWithTag ("Player").transform;

	}
	
	// Update is called once per frame
	void FixedUpdate () {
		this.transform.localPosition = Vector3.Lerp (this.transform.localPosition, player.localPosition, Time.deltaTime * 5f);
	}
}
