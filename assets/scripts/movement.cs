using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class movement : MonoBehaviour {

	Animator anim;
	public Transform center_point;


	void Awake (){

		anim = GetComponent<Animator>();

	}


	void Update (){

		if (anim.GetCurrentAnimatorStateInfo(0).IsTag("turnable"))
		transform.eulerAngles = new Vector3 (transform.eulerAngles.x, center_point.eulerAngles.y, transform.eulerAngles.z);

	}

		
}  