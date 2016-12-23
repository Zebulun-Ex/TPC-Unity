
using UnityEngine;
using System.Collections;

public class player_mov : MonoBehaviour {

	public Animator anim;
	public Rigidbody rbody;

	private Transform player;

	private float inputH;
	private float inputV;
	private bool run;

	// Use this for initialization
	void Start () 
	{
		player = this.transform;
		anim = GetComponent<Animator>();
		rbody = GetComponent<Rigidbody>();
		run = false;
	}

	void RotateAndMove (float deg) {
		float rotate_speed = 10f;
		player.localRotation = Quaternion.LerpUnclamped (player.localRotation, Quaternion.Euler (0, deg, 0), Time.deltaTime * rotate_speed);
	}

	// Update is called once per frame
	void Update () 
	{
		if(Input.GetKey(KeyCode.LeftShift))
		{
			run = true;
		}
		else
		{
			run = false;
		}

		if(Input.GetKey(KeyCode.Space))
		{
			anim.SetBool("jump",true);
		}
		else
		{
			anim.SetBool("jump", false);
		}

		inputH = Input.GetAxis ("Horisontal");
		inputV = Input.GetAxis ("Vertical");

		anim.SetFloat("inputH",inputH);
		anim.SetFloat("inputV",inputV);
		anim.SetBool ("run",run);

		float moveX = inputH*50f*Time.deltaTime;
		float moveZ = inputV*50f*Time.deltaTime;



		if(moveZ < 0f)
		{
			RotateAndMove (-180);
			if (inputV > 0f) {
			}

			else if(run)
			{
				moveX*=3f;
				moveZ*=3f;
			}

		}

		else if(moveZ > 0f)
		{
			RotateAndMove (0);
			if(run)
			{
				moveX*=3f;
				moveZ*=3f;
			}
		}

		else if(moveX > 0f)
		{
			RotateAndMove (90);
			if(run)
			{
				moveX*=3f;
				moveZ*=3f;
			}
		}

		else if(moveX < 0f)
		{
			RotateAndMove (-90);
			if(run)
			{
				moveX*=3f;
				moveZ*=3f;
			}
		}





		rbody.velocity = new Vector3(moveX,0f,moveZ);

	}
}
