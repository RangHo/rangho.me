<script lang="ts">
    import { fly } from "svelte/transition";

    const dischargeDate = new Date(2022, 11, 3).getTime();

    let discharged: boolean;

    let days: number;
    let hours: number;
    let minutes: number;
    let seconds: number;

    // Update the current time every second
    let currentDate = Date.now();
    setInterval(() => {
        currentDate = Date.now();
    }, 1000);

    $: {
        let diff = dischargeDate - currentDate;

        discharged = diff < 0;

        days = Math.max(Math.floor(diff / 1000 / 60 / 60 / 24), 0);
        hours = Math.max(Math.floor((diff / 1000 / 60 / 60) % 24), 0);
        minutes = Math.max(Math.floor((diff / 1000 / 60) % 60), 0);
        seconds = Math.max(Math.floor((diff / 1000) % 60), 0);
    }
</script>

<div class="container">
    <div class="countdown" transition:fly={{ y: -50, duration: 500 }}>
        <ul>
            {#key days}
                <li>
                    <span in:fly={{ y: 50, duration: 500 }}>{days}</span>days
                </li>
            {/key}
            {#key hours}
                <li>
                    <span in:fly={{ y: 50, duration: 500 }}>{hours}</span>hours
                </li>
            {/key}
            {#key minutes}
                <li>
                    <span in:fly={{ y: 50, duration: 500 }}>{minutes}</span
                    >minutes
                </li>
            {/key}
            {#key seconds}
                <li>
                    <span in:fly={{ y: 50, duration: 500 }}>{seconds}</span
                    >seconds
                </li>
            {/key}
        </ul>
    </div>
    {#if discharged}
        <div class="coming-soon" in:fly={{ y: 50, duration: 500, delay: 1000 }}>
            Coming soon...
        </div>
    {/if}
</div>

<style>
    @import url("https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap");

    .container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;

        width: 100%;
        height: 100vh;
        margin: 0 auto;

        color: white;
        text-align: center;

        background: rgba(0, 0, 0, 0.35) url("/img/ocean.jpg");
        background-blend-mode: darken;
        background-position: center;
        background-size: cover;
    }

    .countdown > ul {
        display: flex;
        flex-direction: row;
        justify-content: space-evenly;

        width: 75vw;
        padding: 0;
    }

    li {
        display: inline-block;

        list-style: none;

        font-size: 1.5em;
        font-family: "Do Hyeon", cursive;

        text-transform: uppercase;
    }

    li span {
        display: block;

        font-size: 3em;
    }

    @media (max-width: 480px) {
        li {
            display: inline-block;

            list-style: none;

            font-size: 1em;
            font-family: "Do Hyeon";

            text-transform: uppercase;
        }

        li span {
            display: block;

            font-size: 2em;
        }
    }

    .coming-soon {
        font-size: 3em;
        font-family: "Do Hyeon", cursive;
    }
</style>
